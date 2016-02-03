namespace :import do
  desc "Import everything that you need for developing. "
  task all: [:pledge_classes, :brothers] do
    puts "Imported. "
  end

  desc "Import some brother data for developing convenience. "
  task brothers: :environment do
    file = Rails.root.join("app/assets/brothers.csv")
    lines = File.read(file).lines.select { |x| !x.strip.empty? }

    # Oops
    Brother.destroy_all

    lines.each do |l|
      name, year, pc, k, pos = l.split(',')
      name.strip!
      year = year.to_i
      pc.strip!
      k.strip!
      positions = pos.strip.split(',').map(&:strip).map(&:to_sym)

      if /@/ =~ k
        k = k[0...-8]
      end

      ppc = PledgeClass.find_by(name: pc)

      if ppc.nil?
        puts 'CANNOT FIND PLEDGE CLASS ' + pc
      end

      Brother.create!({
        name: name,
        year: year,
        pledge_class_id: ppc.id,
        kerberos: k, 
        positions: positions
      })

      puts 'Created ' + name
    end

    ['Jiahao Li'].each do |a|
      brother = Brother.find_by!(name: a)
      brother.admin = true
      brother.save!
      puts "Gave system admin privilege to #{a}"
    end
  end

  desc "Import some plege classes for developing convenience. "
  task pledge_classes: :environment do
    classes = {
      'Nomads' => 2015,
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
end
