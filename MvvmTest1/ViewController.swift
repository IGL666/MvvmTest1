//
//  ViewController.swift
//  MvvmTest1
//
//  Created by ggwang on 2021/12/21.
//

import UIKit

class ViewController: UIViewController {

    var currentDateTime = Date()
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBAction func onYesterday() {//현재 시간에서 day를 -1value값을 해서 빼준다
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDateTime) else {
            return
            
        }
        //그리고 빼준 시간을 보여지는 변수값에 넣어준다
        currentDateTime = yesterday
        updateDateTime()
        //집어넣고 업데이트를 해준다.
    }
    @IBAction func onNow() {
        //시간 기본값이 들어오지 않아서 서칭후
        //info.plist
        //프로퍼티 리스트에 App Transport Security Settings값 넣어주고
        //Allow Arbitrary Loads를 yes 값으로 해준다
        //app http 보안상 접근 허용 하지않아 접근을 하기위해 설정
        
        
        fetchNow()
        
    }
    @IBAction func onTomorrow() {  guard let tomorrow = Calendar.current.date(byAdding: .day, value: +1, to: currentDateTime) else {
        return
    }
    currentDateTime = tomorrow
    updateDateTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNow()
    }
    
    // MARK: - FUNC

        // 패치나우를 실행한다.
        private func fetchNow() {
           
            //실제 주소에 가서 json을 가져오고 파싱을 진행한다
            let url = "http://worldclockapi.com/api/json/utc/now"
            
            datetimeLabel.text = "Loading..."
            URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, _, _ in
                guard let data = data else { return }
                guard let model = try? JSONDecoder().decode(UtcTimeModel.self, from: data) else { return }
                
                let formatter = DateFormatter()
               
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
                
                guard let now = formatter.date(from: model.currentDateTime) else { return }
               
                self?.currentDateTime = now
                
                DispatchQueue.main.async {
                    self?.updateDateTime()
                }
                
            }.resume()
       }
        
        private func updateDateTime () {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
            datetimeLabel.text = formatter.string(from: currentDateTime)
            
        }
        
     
        
        
        
        //MARK: - MODEL
            //Codable은 Encodable과 Decodable
            //Encodable -> data를 Encoder에서 변환해주려는 프로토콜로 바꿔주는 것
            // Decodable -> data를 원하는 모델로 Decode 해주는 것
            //json을 예로 들자면,
            //Encodable -> 모델을 json으로 인코드
            //Decodable -> json을 내가 원하는 모델로 디코드
          //json을 파싱하기 위한 코다블 모델
        
        struct UtcTimeModel: Codable {
            let id: String
            let currentDateTime: String
            let utcOffset: String
            let isDayLightSavingsTime: Bool
            let dayOfTheWeek: String
            let timeZoneName: String
            let currentFileTime: Int
            let ordinalDate: String
            let serviceResponse: String? //null값
            //CodingKeys 는 josn key가 아닌 내가원하는 이름으로 지정해주는프로토콜
            enum CodingKeys: String, CodingKey {
              case id = "$id"
              case currentDateTime
              case utcOffset
              case isDayLightSavingsTime
              case dayOfTheWeek
              case timeZoneName
              case currentFileTime
              case ordinalDate
              case serviceResponse
        
            }
        }
    }

