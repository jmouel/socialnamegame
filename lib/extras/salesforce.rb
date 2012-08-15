module Salesforce
  class Client < Databasedotcom::Client

    def initialize(options = {})
      @class_cache = Hash.new
      super(options)
    end

    def find_or_materialize(class_or_classname)
      if class_or_classname.is_a?(Class)
        clazz = class_or_classname
      else
        match = class_or_classname.match(/(?:(.+)::)?(\w+)$/)
        preceding_namespace = match[1]
        classname = match[2]
        raise ArgumentError if preceding_namespace && preceding_namespace != module_namespace.name
        clazz = self.materialize(classname)
      end
      clazz
    end

    def materialize(classnames)
      classes = (classnames.is_a?(Array) ? classnames : [classnames]).collect do |clazz|
        original_classname = clazz
        clazz = original_classname[0].capitalize + original_classname[1..-1]
        new_class = @class_cache[clazz]
        if not new_class
          new_class = module_namespace.const_set(clazz, Class.new(Databasedotcom::Sobject::Sobject))
          new_class.client = self
          new_class.materialize(original_classname)
          @class_cache[clazz] = new_class
        end
        new_class
      end

      classes.length == 1 ? classes.first : classes
    end
  end
end