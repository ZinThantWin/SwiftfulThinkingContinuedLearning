import SwiftUI

struct LongPressView: View {
    @State var isCurrentlyPressing : Bool = false
    @State var isCompleted : Bool = false
    @State var completionPercentage : Double = 0.0
    @State var timer: Timer? = nil
    let minimumDuration: Double = 3.0
    var body: some View {
        ZStack{
            background
            VStack{
                percentage
                button
            }
        }
    }
}

extension LongPressView{
    private var percentage : some View {
        Text(String(format: "%.0f%%", completionPercentage * 100))
            .font(.title)
            .fontWeight(.semibold)
    }
    
    private var button : some View {
        Text("Start")
            .padding(.horizontal,35)
            .padding(.vertical,15)
            .background(Color.blue)
            .cornerRadius(5)
            .onLongPressGesture(minimumDuration: minimumDuration){(isPressing) in
                if isPressing {
                    if isCompleted {
                        isCompleted = false
                        completionPercentage = 0.0
                    }
                    withAnimation(.easeInOut(duration: minimumDuration)){
                        isCurrentlyPressing = true
                    }
                    startTimer()
                }else{
                    stopTimer()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        if !isCompleted {
                            withAnimation(.easeInOut(duration: 0.5)){
                                isCurrentlyPressing = false
                                completionPercentage = 0.0
                            }
                        }
                    }
                }
            } perform:{
                withAnimation(.easeInOut(duration: 0.2)){
                    isCompleted = true
                    isCurrentlyPressing = false
                    completionPercentage = 1.0
                    stopTimer()
                }
            }
    }
    
    private var background : some View {
        Rectangle()
            .fill(isCompleted ? Color.green.gradient : Color.blue.gradient)
            .frame(maxWidth: isCurrentlyPressing || isCompleted ? .infinity : 0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.secondary)
            .ignoresSafeArea()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if completionPercentage < 1.0 {
                completionPercentage += 0.1 / minimumDuration
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    LongPressView().preferredColorScheme(.light)
}
