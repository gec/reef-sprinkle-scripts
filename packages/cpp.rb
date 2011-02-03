package :cpp_test_tools do
  apt('python', 'doxygen', 'ccache')
  verify do
    has_executable 'python'
    has_executable 'doxygen' 
    has_executable 'ccache'
  end  
end

package :cpp_build_tools do 
  requires :build_essentials
  apt('libtool', 'swig', 'sloccount')
  verify do
    has_executable 'libtool'
    has_executable 'swig'
    has_executable 'sloccount'
  end

end

package :exports do

  export_tools = "export TOOLS_HOME=/usr/tools/"
  export_java =  "export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/"

  noop do
    pre :install, "echo \"#{export_tools}\" >> ~/.bashrc"
    pre :install, "echo \"#{export_java}\" >> ~/.bashrc"
  end
  verify do
    file_contains '~/.bashrc', 'TOOLS_HOME'
  end
end



package :arm_cross_compiler do
  requires :build_essentials
  transfer 'installer_scripts/install-crosstool.sh', 'install-crosstool.sh' do
    post :install, "chmod +x install-crosstool.sh"
    post :install, "./install-crosstool.sh"
  end

  verify do
    has_file '/usr/local/opt/crosstool/arm-linux/gcc-3.3.4-glibc-2.3.2/bin/arm-linux-g++'
  end
end