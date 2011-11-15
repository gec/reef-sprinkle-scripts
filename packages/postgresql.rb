package :postgresql, :provides => :database do
  apt %w( postgresql-8.4 )

  verify do
    has_executable 'psql'
    has_version 'psql', '8.4'
  end
end
