require 'hiera'
require 'hiera/scope'
require 'puppet'

module HieraPuppet
  module_function

  def lookup(key, default, scope, override, resolution_type)
   override_hieradata_dir = scope.to_hash['override_hieradata_dir']
   unless scope.respond_to?("[]")
      scope = Hiera::Scope.new(scope)
    end

    answer = hiera(override_hieradata_dir).lookup(key, default, scope, override, resolution_type)

    if answer.nil?
      raise(Puppet::ParseError, "Could not find data item #{key} in any Hiera data file and no default supplied")
    end

    answer
  end

  def parse_args(args)
    # Functions called from Puppet manifests like this:
    #
    #   hiera("foo", "bar")
    #
    # Are invoked internally after combining the positional arguments into a
    # single array:
    #
    #   func = function_hiera
    #   func(["foo", "bar"])
    #
    # Functions called from templates preserve the positional arguments:
    #
    #   scope.function_hiera("foo", "bar")
    #
    # Deal with Puppet's special calling mechanism here.
    if args[0].is_a?(Array)
      args = args[0]
    end

    if args.empty?
      raise(Puppet::ParseError, "Please supply a parameter to perform a Hiera lookup")
    end

    key      = args[0]
    default  = args[1]
    override = args[2]

    return [key, default, override]
  end

  private
  module_function

  def hiera(override_hieradatadir)
    @hiera ||= Hiera.new(:config => hiera_config(override_hieradatadir))
  end

  def hiera_config(override_hieradatadir)
    config = {}

    if config_file = hiera_config_file
      config = Hiera::Config.load(config_file)
    end

    config[:logger] = 'puppet'
    config[:yaml][:datadir] = override_hieradatadir if override_hieradatadir
    config
  end

  def hiera_config_file
    File.exist?('/etc/puppet/hiera.yaml') ? '/etc/puppet/hiera.yaml' : '/etc/hiera.yaml'
  end
end

