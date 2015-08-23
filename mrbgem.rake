MRuby::Gem::Specification.new('mruby-discount') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.linker.libraries << 'markdown'
  require 'open3'

  discount_dir = "#{build_dir}/discount"

  def run_command env, command
    STDOUT.sync = true
    puts "build: [exec] #{command}"
    Open3.popen2e(env, command) do |stdin, stdout, thread|
      print stdout.read
      fail "#{command} failed" if thread.value != 0
    end
  end

  FileUtils.mkdir_p build_dir

  if ! File.exists? discount_dir
    Dir.chdir(build_dir) do
      e = {}
      run_command e, 'git clone git://github.com/Orc/discount.git'
    end
  end

  if ! File.exists? "#{discount_dir}/libmarkdown.a"
    Dir.chdir discount_dir do
      e = {}
      configure_opts = "--disable-shared --enable-static"
      if build.kind_of?(MRuby::CrossBuild) && build.host_target && build.build_target
        configure_opts += " --host #{spec.build.host_target} --build #{spec.build.build_target}"
        e['LD'] = "x86_64-apple-darwin14-ld #{spec.build.linker.flags.join(' ')}" if build.host_target == "x86_64-apple-darwin14"
        e['LD'] = "i386-apple-darwin14-ld #{spec.build.linker.flags.join(' ')}" if build.host_target == "i386-apple-darwin14"

        e['LD'] = "x86_64-w64-mingw32-ld #{spec.build.linker.flags.join(' ')}" if build.host_target == "x86_64-w64-mingw32"
        e['LD'] = "i686-w64-mingw32-ld #{spec.build.linker.flags.join(' ')}" if build.host_target == "i686-w64-mingw32"
      end
      run_command e, "./configure.sh #{configure_opts}"
      run_command e, "make"
    end
  end

  spec.cc.include_paths << discount_dir
  spec.linker.library_paths << discount_dir
end
