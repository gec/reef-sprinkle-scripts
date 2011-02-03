package :mysql, :provides => :database do
  description 'MySQL Database'
  apt %w( mysql-server )
end

package :ruby_mysql_driver do
  requires :mysql
  apt %w(libmysqlclient15-dev libmysql-ruby)
  description 'Ruby MySQL database driver'
  gem 'mysql'
end