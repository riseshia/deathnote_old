require "benchmark/ips"

require "deathnote"
require "okuribito"
require_relative "test_target.rb"

REPEAT = 10_000

okuribito = Okuribito::OkuribitoPatch.new do |method_name, _obj_name, caller_info, class_name, method_symbol|
end
okuribito.apply("candidate_okuribito.yml")
with_once = Okuribito::OkuribitoPatch.new(once_detect: true) do |method_name, _obj_name, caller_info, class_name, method_symbol|
end
with_once.apply("candidate_with_once.yml")

Deathnote.configure do |config|
  config.yaml_path = "candidate_deathnote.yml"
end
Deathnote.start

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("raw") do
    REPEAT.times do
      UserForRaw.new.feed
      UserForRaw.food
    end
  end

  x.report("okuribito") do
    REPEAT.times do
      UserForOkuribito.new.feed
      UserForOkuribito.food
    end
  end

  x.report("with deathnote") do
    REPEAT.times do
      UserForDeathnote.new.feed
      UserForDeathnote.food
    end
  end

  x.report("okuribito with once") do
    # Running code
    REPEAT.times do
      UserForWithOnce.new.feed
      UserForWithOnce.food
    end
  end

  x.compare!
end
