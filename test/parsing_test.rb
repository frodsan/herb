# frozen_string_literal: true

require_relative "helper"

class ParsingTest < Minitest::Test
  test "assignment" do
    template = Herb.parse("<%= 1 + 2 %>")

    assert_equal("3", template.call)
  end

  test "control flow" do
    template = <<-EOT.gsub(/ {4}/, "")
    <% if false %>
      false
    <% else %>
      true
    <% end %>
    EOT

    result = Herb.parse(template).call

    assert_equal("  true\n", result)
  end

  test "parameters" do
    template = <<-EOT.gsub(/ {4}/, "")
    <% params[:n].times do %>
    *
    <% end %>
    EOT

    example = Herb.parse(template)

    assert_equal("*\n*\n*\n", example[n: 3])
    assert_equal("*\n*\n*\n*\n", example[n: 4])
  end

  test "multiline" do
    example = Herb.parse("The\nMan\nAnd\n<%=\"The\"%>\nSea")

    assert_equal("The\nMan\nAnd\nThe\nSea", example.call)
  end

  test "quotes" do
    example = Herb.parse("'foo' 'bar' 'baz'")

    assert_equal("'foo' 'bar' 'baz'", example.call)
  end

  test "context" do
    context = Object.new

    def context.user
      "Bruno"
    end

    example = Herb.parse("<%= user %>", [], context)

    assert_equal("Bruno", example.call)
  end

  test "locals" do
    example = Herb.parse("<%= user %>", [:user], self)

    assert_equal("Mayn", example.call(user: "Mayn"))
  end

  test "nil" do
    example = Herb.parse("<%= params[:user] %>", [], TOPLEVEL_BINDING)

    assert_equal("", example.call(user: nil))
  end

  test "multi-line" do
    template = <<-EOT.gsub(/^    /, "")
    <%
      # Multiline code evaluation
      lucky = [1, 3, 7, 9, 13, 15]
      prime = [2, 3, 5, 7, 11, 13]
    %>

    <%= lucky & prime %>
    EOT

    example = Herb.parse(template)

    assert_equal "\n[3, 7, 13]\n", example.call
  end

  test "escapes by default" do
    text = %q(<>&"')

    template = Herb.parse("<%= params[:text] %>")

    result = template.call(text: text)

    assert_equal("&lt;&gt;&amp;&#39;&#34;", result)
  end

  test "no escaping please" do
    text = %q(<>&"')

    template = Herb.parse("<%== params[:text] %>")

    result = template.call(text: text)

    assert_equal(text, result)
  end
end
