# frozen_string_literal: true

require_relative "helper"

class HelpersTest < Minitest::Test
  include Herb::Helpers

  setup do
    herb_cache.clear
  end

  def foo
    "foo"
  end

  test "using functions in the context" do
    assert_equal("foo\n", herb("test/views/foo.erb"))
  end

  test "passing in a context" do
    assert_raises(NameError) do
      herb("test/views/foo.erb", {}, TOPLEVEL_BINDING)
    end
  end
end
