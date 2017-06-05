Pod::Spec.new do |s|
    s.name         = 'FJTableView'
    s.version      = '0.0.1'
    s.summary      = 'A customized data-driven tableview'
    s.homepage     = 'https://github.com/jeffnjut/FJTableView'
    s.license      = 'MIT'
    s.authors      = {'jeff_njut' => 'jeff_njut@163.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => 'https://github.com/jeffnjut/FJTableView.git', :tag => s.version}
    s.source_files = 'FJTableView/**/*.{h,m}'
    s.dependency     'Masonry'
    s.dependency     'FJTool/Array'
    s.requires_arc = true
end
