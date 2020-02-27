import Foundation

class HttpClient {
    
    static let base = "https://informatica.ieszaidinvergeles.org:9047/app/public/api/"
    
    class func delete(_ route:String,_ callback:@escaping((Data?,URLResponse?,Error?)->Void))->Bool{
        return self.request(route,"delete",nil,callback)
    }
    class func delete(_ route:String,_ callback:@escaping((Data?)->Void))->Bool{
        return self.request(route,"delete",nil,callback)
    }
    class func dict2Json(_ data: [String:Any]) -> Data? {
        guard let json = try? JSONSerialization.data(withJSONObject: data as Any, options: []) else {
            return nil
        }
        print("dict2json json", json)
        return json
    }
    
    class func get(_ route:String,_ callback:@escaping((Data?,URLResponse?,Error?)->Void))->Bool{
        return self.request(route,"get",nil,callback)
    }
    class func get(_ route:String,_ callback:@escaping((Data?)->Void))->Bool{
        return self.request(route,"get",nil,callback)
    }
    
    class func post(_ route:String,_ data:[String:Any],_ callback:@escaping((Data?,URLResponse?,Error?)->Void))->Bool{
        return self.request(route,"post",data,callback)
    }
   class func post(_ route:String,_ data:[String:Any],_ callback:@escaping((Data?)->Void))->Bool{
       return self.request(route,"post",data,callback)
   }
    
    class func put(_ route:String,_ data:[String:Any],_ callback:@escaping((Data?,URLResponse?,Error?)->Void))->Bool{
        return self.request(route,"put",data,callback)
    }
    class func put(_ route:String,_ data:[String:Any],_ callback:@escaping((Data?)->Void))->Bool{
        return self.request(route,"put",data,callback)
    }
    
    
    class func request(_ route: String,_ method:String,_ callBack:@escaping((Data?,URLResponse?,Error?)->Void))->Bool {
        return request(route, method,nil, callBack)
    }
    
    class func request(_ route: String,_ method:String,_ data:[String:Any]?,_ callBack:@escaping((Data?,URLResponse?,Error?)->Void))->Bool{
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        guard let url=URL(string:base+route) else{
            return false
        }

        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod=method
        //urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method != "get" && data != nil{
            guard let diccionario = dict2Json(data!)else{
                return false
            }
            print(diccionario)
            urlRequest.httpBody=diccionario
        }
        let task = sesion.dataTask(with: urlRequest,completionHandler:  callBack)
        task.resume()
        return true
    }
    class func request(_ route: String,_ method:String,_ callBack:@escaping((Data?)->Void))->Bool {
          return request(route, method,nil, callBack)
      }
      class func request(_ route: String,_ method:String,_ data:[String:Any]?,_ callBack:@escaping((Data?)->Void))->Bool{
          return request(route, method, data) { (data, response, error) in
              if response==nil||error != nil||data==nil {
                  print("nil")
                  callBack(nil)
              }else{
                  print("no nil")
                  if let printData=String(data:data!,encoding: .utf8){
                      print(printData)
                  }
                  callBack(data)
              }
          }
      }
    class func upload(route: String,
                      fileParameter: String,//file
                        fileData:Data,
                        callBack: @escaping (_: Data?) -> Void
                        )->Bool{
        //let fileName="ojala camionero"
        guard let url = URL(string: base+route) else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        //Iniciamos el cuerpo de la peticion POST
        body.append(Data("--\(boundary)\r\n".utf8))
        //file name habria que poner el nombre de la foto seleccionada
        body.append(Data("Content-Disposition: form-data; name=\"\(fileParameter)\"; filename=\"\(fileParameter)\"\r\n".utf8))
        body.append(Data("Content-Type: application/octet-stream\r\n\r\n".utf8))
        body.append(fileData)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))
        request.httpBody = body
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesion.dataTask(with: request) { (data, response, error) in
            if response==nil||error != nil||data==nil {
                print("nil")
                callBack(nil)
            }else{
                print("no nil")
                if let printData=String(data:data!,encoding: .utf8){
                    print(printData)
                }
                callBack(data)
            }
        }
        task.resume()
        
        return true
    }
    
    class func upload(route: String,
                                  filePath: String,
                                  fileName:String,//nombre foto
                                  fileParameter: String,//file
                                  formData: [String:String] = [:],
                                  callBack: @escaping (_: Data?, _: URLResponse?, _: Error?) -> Void)    {
        
           guard let url = URL(string: base+route) else {
               return
           }
           let boundary = "Boundary-\(UUID().uuidString)"
           var request = URLRequest(url: url)
           request.httpMethod = "post"
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           var body = Data()
           if formData.count > 0 {
               for (name, value) in formData {
                   body.append(Data("--\(boundary)\r\n".utf8))
                   body.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
                   body.append(Data("\(value)\r\n".utf8))
               }
           }
           body.append(Data("--\(boundary)\r\n".utf8))
           body.append(Data("Content-Disposition: form-data; name=\"\(fileParameter)\"; filename=\"\(fileName)\"\r\n".utf8))
           body.append(Data("Content-Type: application/octet-stream\r\n\r\n".utf8))
           let fileUrl = URL(string: filePath)
           let data = try? Data(contentsOf: fileUrl!)
           body.append(data!)
           body.append(Data("\r\n".utf8))
           body.append(Data("--\(boundary)--\r\n".utf8))
           request.httpBody = body
           let sesion = URLSession(configuration: URLSessionConfiguration.default)
           let task = sesion.dataTask(with: request, completionHandler: callBack)
           task.resume()
       }
    class func uploadId(route: String,
                      fileParameter: String,//file
                        fileData:Data,
                        fileName:String,
                        callBack: @escaping (_: Data?) -> Void
                        )->Bool{
        //let fileName="ojala camionero"
        guard let url = URL(string: base+route) else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        //Iniciamos el cuerpo de la peticion POST
        body.append(Data("--\(boundary)\r\n".utf8))
        //file name habria que poner el nombre de la foto seleccionada
        body.append(Data("Content-Disposition: form-data; name=\"\(fileParameter)\"; filename=\"\(fileName)\"\r\n".utf8))
        body.append(Data("Content-Type: application/octet-stream\r\n\r\n".utf8))
        body.append(fileData)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))
        request.httpBody = body
        let sesion = URLSession(configuration: URLSessionConfiguration.default)
        let task = sesion.dataTask(with: request) { (data, response, error) in
            if response==nil||error != nil||data==nil {
                print("nil")
                callBack(nil)
            }else{
                print("no nil")
                if let printData=String(data:data!,encoding: .utf8){
                    print(printData)
                }
                callBack(data)
            }
        }
        task.resume()
        
        return true
    }
}
