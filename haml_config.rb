require 'json'

def render_file(filename, locals)
  contents = File.read(filename)
  obj = Object.new
  Haml::Engine.new(contents).def_method(obj, :render, :locals)
  obj.render(:locals => locals)
end

def render_static(filename, args = {})
  render_file "app/templates_static/#{filename}.haml", args
end

def load_json(filename)
  JSON.parse(File.read("app/data/#{filename}.json"))
end