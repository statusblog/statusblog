defmodule ErrorReporter do
  def handle_event([:oban, :job, :exception], _measure, meta, _) do
    IO.puts "ERROR!!!"
    IO.inspect meta
  end

  def handle_event([:oban, :circuit, :trip], _measure, meta, _) do
    IO.puts "ERROR!!!"
    IO.inspect meta
  end
end
