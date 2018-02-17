require "benchmark/ips"

require "deathnote"
require "okuribito"
load "test_target.rb"

Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("raw") do
    Object.send(:remove_const, :UserForRaw)
    load "test_target.rb"
    UserForRaw.new.feed
    UserForRaw.food
  end

  x.report("okuribito") do
    Object.send(:remove_const, :UserForOkuribito)
    load "test_target.rb"
    okuribito = Okuribito::OkuribitoPatch.new do |method_name, _obj_name, caller_info, class_name, method_symbol|
    end
    okuribito.apply("candidate_okuribito.yml")

    UserForOkuribito.new.feed
    UserForOkuribito.food
  end

  x.report("with deathnote") do
    Object.send(:remove_const, :UserForDeathnote)
    load "test_target.rb"
    Deathnote.configure do |config|
      config.yaml_path = "candidate_deathnote.yml"
    end
    Deathnote.start

    UserForDeathnote.new.feed
    UserForDeathnote.food
  end

  x.report("okuribito with once") do
    Object.send(:remove_const, :UserForWithOnce)
    load "test_target.rb"
    with_once = Okuribito::OkuribitoPatch.new(once_detect: true) do |method_name, _obj_name, caller_info, class_name, method_symbol|
    end
    with_once.apply("candidate_with_once.yml")

    UserForWithOnce.new.feed
    UserForWithOnce.food
  end

  x.compare!
end
