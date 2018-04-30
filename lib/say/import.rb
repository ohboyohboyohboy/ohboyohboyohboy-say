#!/usr/bin/ruby
# encoding: utf-8
#
# author: Kyle Yetter
#

require 'say'

class ::Object
  include Say
end

class IO
  public :say
end