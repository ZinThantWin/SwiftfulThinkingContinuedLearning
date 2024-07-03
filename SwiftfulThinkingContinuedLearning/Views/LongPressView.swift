import SwiftUI

struct LongPressView: View {
    @State var isCurrentlyPressing : Bool = false
    @State var isCompleted : Bool = false
    var body: some View {
        ZStack{
                Rectangle()
                    .fill(isCompleted ? Color.green.gradient : Color.blue.gradient)
                    .frame(maxWidth: isCurrentlyPressing || isCompleted ? .infinity : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.secondary)
                    .ignoresSafeArea()
                Text("Start")
                    .padding(.horizontal,35)
                    .padding(.vertical,15)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .onLongPressGesture(minimumDuration: 3){(isPressing) in
                        if isPressing {
                            if isCompleted {
                                isCompleted = false
                            }
                            withAnimation(.easeInOut(duration: 3)){
                                isCurrentlyPressing = true
                            }
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                                if !isCompleted {
                                    withAnimation(.easeInOut(duration: 0.5)){
                                        isCurrentlyPressing = false
                                    }
                                }
                            }
                        }
                    } perform:{
                        withAnimation(.easeInOut(duration: 0.2)){
                            isCompleted = true
                            isCurrentlyPressing = false
                        }
                    }
        }
    }
}

#Preview {
    LongPressView().preferredColorScheme(.light)
}
