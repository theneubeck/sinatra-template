module PlugableRouter
  
  def mount(models, &block)
    m = models.to_s[/(\w+)$/]
    model_name  = m.to_s.singularize
    models_name = m.to_s.pluralize
    model_class = model_name.capitalize.constantize
        
    c = Controller.new(models.to_s, self)
    c.instance_eval(&block) if block_given?
    c.instance_eval do
      
      get '/?' do
        instance_variable_set("@#{models_name}", model_class.all)
        haml :"#{models_name}/index"
      end
      
      get '/new' do
        instance_variable_set("@#{model_name}", model_class.new)
        haml :"#{models_name}/new"
      end
      
      get '/:id' do
        instance_variable_set("@#{model_name}", model_class[params[:id].to_i])
        @comment = Comment.new(:homepage => "http://")
        haml :"#{models_name}/show"
      end

      get '/:id/edit' do
        instance_variable_set("@#{model_name}", model_class[params[:id].to_i])
        haml :"#{models_name}/edit"
      end
      
      post '/?' do
        instance_variable_set("@#{model_name}", model_class.new(params[model_name.to_sym]))
        model = instance_variable_get("@#{model_name}")
        if model.valid? && model.save
          flash[:notice] = "#{model_name} created!"
          redirect "/#{models.to_s}"
        else
          haml :'#{models_name}/new'
        end
      end
      
      put '/:id' do    
        instance_variable_set("@#{model_name}", model_class[params[:id].to_i])
        model = instance_variable_get("@#{model_name}")

        if model.update(params[model_name.to_sym])
          flash[:notice] = "Artikeln uppdaterad"
          redirect "/#{models_name}"
        else
          haml :"#{models_name}/edit"
        end
      end
      
      delete '/:id' do
        model_class[params[:id].to_i].destroy
        redirect "/#{models.to_s}"
      end
      
    end
  end

  class Controller
    attr_reader :prefix, :caller
    
    def initialize(prefix, caller)
      @caller = caller
      @prefix = prefix
      @called_methods = {}
    end

    def get(*args, &block)
      do_call(:get, *args, &block)
    end

    def delete(*args, &block)
      do_call(:delete, *args, &block)
    end

    def put(*args, &block)
      do_call(:put, *args, &block)
    end

    def post(*args, &block)
      do_call(:post, *args, &block)
    end
  
    private
      
      def do_call(method, *args, &block)
        path = "/#{prefix}#{args.pop}"
        unless @called_methods.has_key?("#{method}#{path}")
          @called_methods["#{method}#{path}"] = true
          @caller.send(method, path, *args, &block)
        end
      end
  end
  
  
end