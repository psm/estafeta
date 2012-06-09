#Estafeta + Boxcar
Andar revisando la página de Estafeta para saber qué pedo con tus pedidos es una hueva, así que hicimos este pequeño app en Ruby (>= 1.9.2p180) que usa el servicio de Push Notifications de [Boxcar](http://boxcar.io) para avisarte cuándo tu pedido cambie de status.

**Es necesario tener en tu iPhone el app de Boxcar, que puedes [bajar acá](http://itunes.apple.com/us/app/boxcar/id321493542?mt=8).**

## Install
    gem install httparty nokogiri daemons boxcar_api
    git clone https://github.com/psm/estafeta.git

## Usage
    ./revisa NUMERO_DE_GUIA TU_CORREO_DE_BOXCAR
	
Para detener, hay que llamar:

    ./revisa stop
	

##Licencia
Copyright (c) 2012 Partido Surrealista Mexicano

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.