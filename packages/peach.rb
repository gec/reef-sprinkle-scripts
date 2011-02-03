package :peach_apt_deps do
  # we don't run the including twisted 8.2.0 since it conflicts with the 10.0.1 version
  # installed on lucid
  apt('unzip', 'python', 'python-dev', 'python-twisted-web')
end

package :peach_download do
  requires :peach_apt_deps
  noop do
    pre :install, "wget http://sourceforge.net/projects/peachfuzz/files/Peach/2.3.6/Peach-2.3.6-src.zip/download"
    pre :install, "unzip Peach-2.3.6-src.zip"
  end
  verify do
    has_file 'Peach-2.3.6/readme.html'
  end
end

package :peach_dependencies do
  requires :peach_download
  noop do
    # we do the true && to get out of the sudo context applied to the first command
    pre :install, "true && cd Peach-2.3.6/dependencies/src/ && sudo unzip vdebug-022710"

    taredDeps = ['multiprocessing-2.6.2.1.tar.gz','zope.interface-3.3.0.tar.gz']
    taredDeps.each do |dep|
      pre :install, "true && cd Peach-2.3.6/dependencies/src/ && sudo tar -xf #{dep}"
    end

    deps = ['cPeach', '4Suite-XML-1.0.2', 'cDeepCopy', 'multiprocessing-2.6.2.1','zope.interface-3.3.0','vdebug-022710']
    deps.each do |dep|
      pre :install, "true && cd Peach-2.3.6/dependencies/src/#{dep}/ && sudo python setup.py install"
    end
  end
  verify do
    has_file 'Peach-2.3.6/dependencies/src/vdebug-022710/README'
  end
end

package :peach do
  requires :peach_dependencies
  noop do
    pre :install, 'echo "python `pwd`/Peach-2.3.6/peach.py \"\$@\"" > peach'
    pre :install, 'chmod +x peach'
    pre :install, 'mv peach /usr/local/sbin/peach'
  end
  verify do
    has_executable 'peach'
  end
end

