module Fontina

  module Windows::QualifiedName
    QualifiedName.include self

    PRIMARY = /^[^-]*/
    private_constant :PRIMARY

    def score
      @score ||=
        case platform
        when :unicode then 3
        when :mac then 5 if language == Windows.system_language[PRIMARY]
        when :windows
          if language == Windows.system_language then 7
          elsif language[PRIMARY] == Windows.system_language[PRIMARY] then 6
          elsif language == 'en-US' then 2
          else 1
          end
        end || 0
    end
  end

  module Windows::PreferredName
    Font.include self
    Package.include self

    def preferred_name
      @preferred_name = names.max_by &:score unless defined? @preferred_name
      @preferred_name
    end
  end

end
