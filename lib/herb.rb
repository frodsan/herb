# frozen_string_literal: true

# Copyright (c) 2016      Francesco Rodríguez
# Copyright (c) 2011-2016 Michel Martens (https://github.com/soveran/mote)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Herb
  PATTERN = /(<%)\s+(.*?)\s+%>(?:\n)|(<%==?)(.*?)%>/m

  def self.parse(template, vars = [], context = self)
    terms = template.split(PATTERN)
    parts = "proc do |params = {}, __o = ''|\n".dup

    vars.each { |var| parts << sprintf("%s = params[%p]\n", var, var) }

    while (term = terms.shift)
      parts << parse_expression(terms, term)
    end

    parts << "__o; end"

    compile(context, parts)
  end

  def self.parse_expression(terms, term)
    case term
    when "<%"   then terms.shift << "\n"
    when "<%="  then "__o << Herb.h((" + terms.shift << ").to_s)\n"
    when "<%==" then "__o << (" + terms.shift << ").to_s\n"
    else             "__o << " + term.dump << "\n"
    end
  end

  def self.compile(context, parts)
    context.instance_eval(parts)
  end

  HTML_ESCAPE = {
    "&" => "&amp;",
    ">" => "&gt;",
    "<" => "&lt;",
    '"' => "&#39;",
    "'" => "&#34;"
  }.freeze

  UNSAFE = /[&"'><]/

  def self.h(str)
    str.gsub(UNSAFE, HTML_ESCAPE)
  end

  module Helpers
    def herb(file, params = {}, context = self)
      herb_cache[file] ||= Herb.parse(File.read(file), params.keys, context)
      herb_cache[file].call(params)
    end

    def herb_cache
      Thread.current[:herb_cache] ||= {}
    end
  end
end
