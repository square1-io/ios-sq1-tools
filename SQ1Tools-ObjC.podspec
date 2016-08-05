Pod::Spec.new do |s|
    s.platform = :ios
    s.name              = 'SQ1Tools-ObjC'
    s.version           = '0.1.1'
    s.summary           = 'This library contains a group of utilities, helpers and categories that can be use in the different iOS projects we develope.'
    s.homepage          = 'https://github.com/square1-io/ios-sq1-tools'
    s.license           = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author            = {
        'Rober Pastor' => 'rober@square1.io'
    }
    s.source            = {
        :git => 'https://github.com/square1-io/ios-sq1-tools.git',
        :tag => s.version.to_s
    }
    s.source_files      = 'SQ1Tools-ObjC/Source/*/*.{m,h}', 'SQ1Tools-ObjC/*.h'
    s.requires_arc      = true

end
