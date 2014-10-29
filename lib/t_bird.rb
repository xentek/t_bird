# encoding: utf-8

require 't_bird/configuration'
require 't_bird/namer'
require 't_bird/processor'
require 't_bird/transmitter'
require 't_bird/uploader'
require 't_bird/version'
require 'tempfile'

module TBird
  module Errors
    class Unknown < StandardError ; end
  end
end
