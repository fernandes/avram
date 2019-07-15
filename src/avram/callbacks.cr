module Avram::Callbacks
  macro before_save(method)
    def before_save
      {% if @type.methods.map(&.name).includes?(:before_save.id) %}
        previous_def
      {% end %}

      {{ method.id }}
    end
  end

  macro after_save(method)
    def after_save(object)
      {% if @type.methods.map(&.name).includes?(:after_save.id) %}
        previous_def
      {% end %}

      {{ method.id }}(object)
    end
  end

  macro after_commit(method)
    def after_commit(object)
      {% if @type.methods.map(&.name).includes?(:after_commit.id) %}
        previous_def
      {% end %}

      {{ method.id }}(object)
    end
  end

  {% for removed_callback in [:create, :update] %}
    # :nodoc:
    macro after_{{ removed_callback.id }}(method_name)
      \{% raise "'after_#{removed_callback}' has been removed" %}
    end

    # :nodoc:
    macro before_{{ removed_callback.id }}(method_name)
      \{% raise "'before_#{removed_callback.id}' has been removed" %}
    end
  {% end %}
end
