module Dropcaster
  #
  # Encapsulates the strategy how to find the channel definition file
  #
  class ChannelFileLocator
    class << self
      #
      # Locates the channel definition file based on the <tt>sources</tt> directory.
      #
      # * If <tt>sources</tt> is a single file name, the channel definition file is expected
      # as channel.yml in the same directory.
      #
      # * If <tt>sources</tt> is a single directory name, the channel definition file is
      # expected as channel.yml in that directory.
      #
      # * If <tt>sources</tt> is an array of file names, the channel definition file is
      # expected as channel.yml in the directory common to all files. If the files are
      # located in more than one directory, an AmbiguousSourcesError is raised. In that
      # case, the caller should specify the channel.yml as command line parameter.
      #
      # * If <tt>sources</tt> is an array with more than a single directory name, an
      # AmbiguousSourcesError is raised. In that case, the caller should specify the
      # channel.yml as command line parameter.
      #
      def locate(sources)
        channel_source_dir = nil

        if sources.respond_to?(:at)
          # More than one source given. Check that they are all in the same directory.
          distinct_dirs = sources.collect{|source| File.dirname(source)}.uniq

          if 1 == distinct_dirs.size
            # If all are the in same directory, use that as source directory where channel.yml is expected.
            channel_source_dir = distinct_dirs.first
          else
            # Since no channel_file was specified at the command line, throw and quit
            raise AmbiguousSourcesError.new(sources)
          end
        else
          # If a single file or directory is given, use that as source directory where channel.yml is expected.
          channel_source_dir = File.dirname(sources)
        end

        File.join(channel_source_dir, 'channel.yml')
      end
    end
  end
end
