require 'vcr'

module Core::Repository
  class VCR < SimpleDelegator
    def method_missing(method_name, *args, &block)
      klass = if __getobj__.class.superclass == SimpleDelegator
                __getobj__.__getobj__.class
              else
                __getobj__.class
              end

      cassette_name = [I18n.locale, klass.name.underscore, method_name, *args].join('/')

      Marshal.load(Marshal.dump(::VCR.use_cassette(cassette_name) { super }))
    end
  end
end
