# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'root@issues.com', password: '12345678', firstname: 'Root', lastname: 'User')
User.create(email: 'example.user@mail.com', password: '12345687', firstname: 'Example', lastname: 'User')

if Rails.env.development?
  lorem = """
    Quis fuga unde numquam. Et atque aliquid asperiores officia enim quibusdam ipsam. Eius sit molestiae et in voluptatem
    quas molestiae velit. Sint laborum doloribus ut officiis quam illo. Minima hic mollitia numquam corrupti repudiandae
    animi eius eligendi. Rerum tenetur blanditiis sit rem enim. Occaecati iste cupiditate est. Repudiandae hic assumenda
    doloremque quis doloremque vero aut.
  """

  project = Project.create(name: 'Issues Dev', version: '0.1')

  jane    = User.create(email: 'janedoe@gmail.com',            password: '12345687', firstname: 'Jane',    lastname: 'Doe')
  john    = User.create(email: 'johndoe@me.com',               password: '12345687', firstname: 'John',    lastname: 'Doe')
  hugh    = User.create(email: 'hughjackman@me.com',           password: '12345687', firstname: 'Hugh',    lastname: 'Jackman')
  axl     = User.create(email: 'axlrose@gnr.com',              password: '12345687', firstname: 'Axl',     lastname: 'Rose')
  anthony = User.create(email: 'anthonykiedis@rhcp.com',       password: '12345687', firstname: 'Anthony', lastname: 'Kiedis')
  james   = User.create(email: 'jameshetfield@metallica.com',  password: '12345687', firstname: 'James',   lastname: 'Hetfield')
  robert  = User.create(email: 'robertplant@led-zeppelin.com', password: '12345687', firstname: 'Robert',  lastname: 'Plant')
  stevie  = User.create(email: 'stevienicks@me.com',           password: '12345687', firstname: 'Stevie',  lastname: 'Nicks')

  Label.create(title: 'Bug', color: '#B84750')
  Label.create(title: 'Testing', color: '#C37F45')
  Label.create(title: 'Work in Progress', color: '#5A3390')
  Label.create(title: 'Feature Request', color: '#6E9DB2')
  Label.create(title: 'Won\'t fix', color: '#506879')
  Label.create(title: 'Duplicate', color: '#B7C4CA')
  Label.create(title: 'Patch', color: '#4B8576')

  Report.create(title: 'A Title', description: lorem, project: project, reporter: jane)
  Report.create(title: 'Another Title', description: lorem, project: project, reporter: john)
  Report.create(title: 'Yet another Title', description: lorem, project: project, reporter: jane)
  Report.create(title: 'A Report', description: lorem, project: project, reporter: robert)
  Report.create(title: 'Another Report', description: lorem, project: project, reporter: stevie)
  Report.create(title: 'Yet another Report', description: lorem, project: project, reporter: hugh)
  Report.create(title: 'Lorem ipsum', description: lorem, project: project, reporter: anthony)
  Report.create(title: 'More Lorem ipsum', description: lorem, project: project, reporter: axl)
  Report.create(title: 'Clark Kent is Superman', description: lorem, project: project, reporter: john)
  Report.create(title: 'Hugh Jackman is Wolverine', description: lorem, project: project, reporter: jane)
  Report.create(title: 'Smarties & Nutella', description: lorem, project: project, reporter: john)
  Report.create(title: 'One more Report', description: lorem, project: project, reporter: john)
end
