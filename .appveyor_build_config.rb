MRuby::Build.new do |conf|
  conf.gembox 'default'
  conf.gem '..'

  conf.cc do |cc|
    cc.command = "x86_64-w64-mingw32-gcc"
  end

  conf.mrbc do |mrbc|
    mrbc.command = "mrbc.exe"
  end

  conf.linker do |linker|
    linker.command = "x86_64-w64-mingw32-gcc"
  end

  conf.archiver do |archiver|
    archiver.command = 'x86_64-w64-mingw32-ar'
  end

  conf.exts do |exts|
    exts.object = '.o'
    exts.executable = '.exe' # '.exe' if Windows
    exts.library = '.a'
  end
end
