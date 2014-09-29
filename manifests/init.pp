include stdlib

class zookeeper (
	$servers,
	$downloadDir = '/zookeeper',
	$zooVersion = '3.4.6',
	$downloadUrl = 'http://mirror.ox.ac.uk/sites/rsync.apache.org/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz'
	) {
	file { ["/var/lib/zookeeper",
		"/var/lib/zookeeper/data"
		]:
		ensure => directory,
    	mode => 755,
	}

	file { "$downloadDir/":
		ensure => directory,
		require => [ 
			File["/var/lib/zookeeper"],
			File["/var/lib/zookeeper/data"]
			],
	}

	exec {'download-zoo' :
		command => "/usr/bin/wget -O $downloadDir/zookeeper-$zooVersion.tar.gz $downloadUrl",
		creates => "$downloadDir/zookeeper-$zooVersion.tar.gz",
		require => File["$downloadDir/"],
		notify 	=> Exec['extract-zoo'],
	}

	exec { 'extract-zoo' :
		command => "/bin/chmod a+x $downloadDir/zookeeper-$zooVersion.tar.gz && /bin/tar -xzf $downloadDir/zookeeper-$zooVersion.tar.gz -C /usr/local/",
		creates => "/usr/local/zookeeper-$zooVersion",
	}

	file { "/usr/local/zookeeper":
    	ensure => link,
    	target => "/usr/local/zookeeper-$zooVersion",
    	require => Exec["extract-zoo"],
  	}
}
