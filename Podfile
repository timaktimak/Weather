
use_frameworks!

target 'Weather' do
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'SDWebImage'
    # Alamofire+SwiftyJSON использую, так как это свифтовые библиотеки и они нормально работают под swift
    # RestKit не поддерживает свифтовые типы, приходится извращаться, использовать NSNumber вместо Double,
    # не получается использовать optionals, архитектуру приходится подстраивать под RestKit, что плохо
    
    # RestKit не поддерживает трансформацию типов, на obj-c стоит рассматривать и EasyMapping или Mantle
    # Но в RestKit круто, что он работает поверх AFNetworking, и поэтому даже код запроса не нужно писать, кода
    # получается меньше
end

