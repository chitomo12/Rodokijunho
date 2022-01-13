//
//  AlertData.swift
//  Rodokijunho
//
//  Created by 福田正知 on 2021/12/27.
//

import AVFoundation

let alertPath = Bundle.main.bundleURL.appendingPathComponent("alert1.mp3")
let alertPath2 = Bundle.main.bundleURL.appendingPathComponent("alert2.mp3")
var alertPlayer = AVAudioPlayer()
var alertPlayer2 = AVAudioPlayer()

func playAlertAudio(){
    do{
        alertPlayer = try AVAudioPlayer(contentsOf: alertPath, fileTypeHint: nil)
        alertPlayer.play()
        alertPlayer2 = try AVAudioPlayer(contentsOf: alertPath2,fileTypeHint: nil)
        alertPlayer2.play()
    } catch {
        print("音源再生時にエラーが発生しました")
    }
}

func stopAlertAudio(){
    alertPlayer.stop()
    alertPlayer2.stop()
}
