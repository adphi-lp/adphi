namespace :import do
  desc "Import everything that you need for developing. "
  task all: [:pledge_classes, :brothers, :officers] do
    puts "Imported. "
  end

  desc "Import some brother data for developing convenience. "
  task brothers: :environment do
    file = Rails.root.join("app/assets/brothers.csv")
    lines = File.read(file).lines.select { |x| !x.strip.empty? }

    # Oops
    Brother.destroy_all

    lines.each do |l|
      name, year, pc, k = l.split(',')
      name.strip!
      year = year.to_i
      pc.strip!
      k.strip!

      if /@/ =~ k
        k = k[0...-8]
      end

      ppc = PledgeClass.find_by(name: pc)

      if ppc.nil?
        puts 'CANNOT FIND PLEDGE CLASS ' + pc
      end

      Brother.create({
        name: name,
        year: year,
        pledge_class_id: ppc.id,
        kerberos: k
      })

      puts 'Created ' + name
    end
  end

  desc "Import some plege classes for developing convenience. "
  task pledge_classes: :environment do
    classes = {
      'Wolfpack' => 2014,
      'Muses' => 2013,
      'Atlas' => 2012,
      'Celeritas' => 2011,
      'Pendulum' => 2010,
      'Prodromos' => 2009,
    }

    PledgeClass.destroy_all

    classes.each do |n, y|
      PledgeClass.create({
        name: n,
        year: y
      })

      puts 'Created ' + n
    end
  end

  desc "Assign brothers to some positions"
  task officers: :environment do
    officers = {
      'Alec Heifetz' => :president,
      'Richard Hsu' => :treasurer
    }

    officers.each do |k, v|
      brother = Brother.find_by!(name: k)
      brother.position = Brother.positions[v]
      brother.save!

      puts "Appointed #{k} as #{v.to_s.humanize}"
    end

    ['Jiahao Li'].each do |a|
      brother = Brother.find_by!(name: a)
      brother.admin = true
      brother.save!
      puts "Gave system admin privilege to #{a}"
    end
  end
end
