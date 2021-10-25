import UIKit

protocol Human {
    var isAlive: Bool { get set }
}

protocol Died {
    func riseUp()
}

class Сemetery<T:Died>{
    
    var people: [T]?
    
    func riseUpZombies() {
        guard let people = people else {
            return
        }

        for corpse in people {
            corpse.riseUp()
        }
    }
}

extension Сemetery where T: Human {
    func humanCeremony() {
        print("HUMAN CEREMONY")
    }
}




protocol FaceTimeCall {
    associatedtype CallerDeviceType
    associatedtype HostDeviceType
    func call(caller: CallerDeviceType, host: HostDeviceType)
}

private class _AnyCallingBox<CallerDeviceType, HostDeviceType>: FaceTimeCall {
    func call(caller: CallerDeviceType, host: HostDeviceType) {
        fatalError("This method is abstract")
    }
}

private class _CallingBox<Base: FaceTimeCall>:
      _AnyCallingBox<Base.CallerDeviceType, Base.HostDeviceType> {
   private let _base: Base
   init(_ base: Base) {
      _base = base
   }
   override func call(caller: Base.CallerDeviceType, host: Base.HostDeviceType) {
       return _base.call(caller: caller, host: host)
   }
}

struct AnyObjectCall<CallerDeviceType, HostDeviceType>: FaceTimeCall {
   private let _box: _AnyCallingBox<CallerDeviceType, HostDeviceType>
   init<MapperType: FaceTimeCall>(_ mapper: MapperType)
    where MapperType.CallerDeviceType == CallerDeviceType,
            MapperType.HostDeviceType == HostDeviceType {
      
      _box = _CallingBox(mapper)
   }
    func call(caller: CallerDeviceType, host: HostDeviceType) {
        return _box.call(caller: caller, host: host)
    }
}

class IPhoneDevice { }
class IPadDevice { }
class IPhoneToIPad: FaceTimeCall {
    func call(caller: IPhoneDevice, host: IPadDevice) {
        print("Call")
    }
}
class ArticleService {
   var mapper: AnyObjectCall<IPhoneDevice, IPadDevice>!
}
