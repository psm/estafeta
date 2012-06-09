#!/usr/bin/env ruby
#encoding: utf-8
require 'daemons'


options = {
  :app_name => 'Estafeta',
  :multiple => false,
  :log_output => true,
}
Daemons.run('estafeta.rb', options)