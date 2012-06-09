#!/usr/bin/env ruby
#encoding: utf-8

require 'httparty'
require 'nokogiri'
require 'boxcar_api'
require 'json'
require 'logger'
require 'daemons'

query = {
  method: '',
  forward:  '',
  idioma: 'es',
  pickUpId: '',
  dispatch: 'doRastreoInternet',
  tipoGuia: 'ESTAFETA',
  guias: ARGV[0],
  'image.x' => '55',
  'image.y' => '10'
}

BOXCAR_API_SECRET = 'blcJvwePqIXTPbp2I55kiucThnVGab2f8fVv6HRW'
BOXCAR_API_KEY = '8qPsD6HfIal4YjweLIKQ'

boxcar = BoxcarAPI::Provider.new(BOXCAR_API_KEY, BOXCAR_API_SECRET, "Estafeta")
boxcar.subscribe ARGV[1]

filePath = "#{File.expand_path(File.dirname(__FILE__))}/cache.json"
begin
  cache = File.open(filePath, 'r+:UTF-8')
rescue Exception => e
  cache = File.open(filePath, 'w+:UTF-8')
end
status = cache.read
if status == ''
  status = {}
else
  status = JSON.parse status
end

loop {
  begin
    r = HTTParty.post('http://rastreo3.estafeta.com/RastreoWebInternet/consultaEnvio.do', :body => query)
    doc = Nokogiri::HTML(r.body)
    rows = doc.css('form > table tr')

    log = Logger.new(STDOUT)
    #log.level = Logger::WARN

    keys = {
      "Guía"=>"guia",
      "Código de Rastreo"=>"codigo_rastro",
      "Guías envíos múltiples"=>"guia_multiples",
      "Guía documento de retorno"=>"guia_documento",
      "Servicio"=>"servicio",
      "Fecha programada  de entrega"=>"fecha_programada",
      "Guía internacional"=>"guia_internacional",
      "Origen"=>"origen",
      "Fecha de recolección"=>"recoleccion",
      "Destino"=>"destino",
      "CP Destino"=>"cp",
      "Estatus del envío"=>"status",
      "Fecha y hora de entrega"=>"fecha_actual",
      "Recibió"=>'recibio',
      "Tipo de envío"=>"tipo",
      "Dimensiones cm"=>"dimensiones",
      "Peso kg"=>"peso",
      "Peso volumétrico kg"=>"peso_vol",
      "Referencia cliente"=>"referencia",
      "Número de orden de recolección"=>"orden_recoleccion",
      "Orden de Rastreo*"=>"orden_rastreo"
    }


    if rows[1].css('td')[0].text =~ /no hay información disponible/i
      log.info "Not yet :("
      status['6015056308464750161742'] = {'status'=>'PENDIENTE'}
    else
      log.info "Hay info!"
      info = {}
      key = ''
      rows.css('td.style1, td.style9').each_with_index do |td, index|;
        if (index % 2) ==0
          val = td.text
          if val == ''
            #skip = true;
            next 2
          end
          key = keys[val] || val
        else
          value = td.text.strip
          value = if value == '' then nil else value; end      
          info[key] = value
        end
      end
      
      if !status.has_key?(info['guia'])
        status[info['guia']] = info
        log.info "El status cambió de PENDIENTE a #{info['status']}";
        boxcar.notify("rob@unrob.com", "Guía: #{info['guia']} --- Status: #{info['status']} --- Fecha de entrega programada: #{info['fecha_programada']} ", :icon_url => 'http://www.estafeta.com/imagenes/estafeta.ico')
      elsif status[info['guia']]['status'] != info['status']
        status[info['guia']] = info
        log.info "El status cambió de #{status[info['guia']]['status']} a #{info['status']}";
        boxcar.notify("rob@unrob.com", "Guía: #{info['guia']} --- Status: #{info['status']} --- Fecha de entrega programada: #{info['fecha_programada']} ", :icon_url => 'http://www.estafeta.com/imagenes/estafeta.ico')
      end
 
    end
  
  log.info "Run done"
  sleep 60*30;
  rescue Interrupt =>e 
    log.info "Guardando cache..."
    cache.rewind
    cache.write status.to_json
    exit
  end
}
