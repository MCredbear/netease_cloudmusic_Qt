function play(id) {
    var songUrl = neteaseAPI.songUrl(id)
    if (songUrl !== "") {
        var json = JSON.parse(songUrl)
        if (json.code === 500) {
            bannedToast.open()
        } else {
            player.source = json.data[0].url
            player.play()
            var lyric = neteaseAPI.lyric(id)
            if (lyric !== "") {
                const tiArAlByExpression = /^\[(ti|ar|al|by):(.*)\]$/
                const lyricExpression = /^\[(\d{2}):(\d{2}).(\d{2}|\d{3})\](.*)/
                var lyricJson = JSON.parse(lyric)
                var lyricVersion = lyricJson.lrc.version
                if (/*lyricVersion === 1 | */lyricVersion === 0) {
                    lyricView.hasLyric = false
                    lyricView.autoScroll = false
                    lyricView.model.clear()
                }
                else {
                    lyricView.hasLyric = true
                    lyricView.autoScroll = !lyricJson.sgc
                    var originalLyric = lyricJson.lrc.lyric
                    var translatedLyric = lyricJson?.tlyric?.lyric ?? ""
                    var romanianLyric = lyricJson?.romalrc?.lyric ?? ""
                    var originalLyricModel = []
                    var translatedLyricModel = []
                    var romanianLyricModel = []
                    if (lyricJson.sgc) {
                        originalLyricModel.push({
                                                 "time": -1,
                                                 "originalLyric": originalLyric})
                        translatedLyricModel.push({
                                                   "time": -1,
                                                   "translatedLyric": -1})
                        romanianLyricModel.push({
                                                 "time": -1,
                                                 "romanianLyric": romanianLyric})
                    }
                    else {
                        var result
                        originalLyricModel = originalLyric.split("\n")
                        .filter(function(value){
                            return !(value.match(tiArAlByExpression) !== null | value.trim() === "" | ((value.match(lyricExpression) !== null) ? (value.match(lyricExpression)[4].trim() === "") : false))
                        })
                        .map(function(value){
//                                        if ((result = value.match(lyricExpression)) !== null) {
                            result = value.match(lyricExpression)
                                return {
                                    "time": Number(result[1]) * 60 * 1000 + Number(result[2]) * 1000 + ((result[3].length > 2) ? Number(result[3]) : Number(result[3]) * 10),
                                    "originalLyric": result[4]
                                }
//                                        }
                        })
                        translatedLyricModel = translatedLyric.split("\n")
                        .filter(function(value){
                            return !(value.match(tiArAlByExpression) !== null | value.trim() === "" | ((value.match(lyricExpression) !== null) ? (value.match(lyricExpression)[4].trim() === "") : false))
                        })
                        .map(function(value){
//                                        if ((result = value.match(lyricExpression)) !== null) {
                            result = value.match(lyricExpression)
                                return {
                                    "time": Number(result[1]) * 60 * 1000 + Number(result[2]) * 1000 + ((result[3].length > 2) ? Number(result[3]) : Number(result[3]) * 10),
                                    "translatedLyric": result[4]
                                }
//                                        }
                        })
                        if (translatedLyricModel.length > 0) lyricView.hasTranslatedLyric = true
                            else lyricView.hasTranslatedLyric = false
                        romanianLyricModel = romanianLyric.split("\n")
                        .filter(function(value){
                            return !(value.match(tiArAlByExpression) !== null | value.trim() === "" | ((value.match(lyricExpression) !== null) ? (value.match(lyricExpression)[4].trim() === "") : false))
                        })
                        .map(function(value){
//                                        if ((result = value.match(lyricExpression)) !== null) {
                            result = value.match(lyricExpression)
                                return {
                                    "time": Number(result[1]) * 60 * 1000 + Number(result[2]) * 1000 + ((result[3].length > 2) ? Number(result[3]) : Number(result[3]) * 10),
                                    "romanianLyric": result[4]
                                }
//                                        }
                        })
                        if (romanianLyricModel.length > 0) lyricView.hasRomanianLyric = true
                            else lyricView.hasRomanianLyric = false
                    }
                    var lyricModel = []
                    for (var i in originalLyricModel) {
                        var _translatedLyric = ""
                        var _romanianLyric = ""
                        for (var j in translatedLyricModel) if (translatedLyricModel[j].time === originalLyricModel[i].time) {
                                                                                                                        _translatedLyric = translatedLyricModel[j].translatedLyric
                                                                                                                        break
                                                                                                                        }
                        for (var k in romanianLyricModel) if (romanianLyricModel[k].time === originalLyricModel[i].time) {
                                                                                                                        _romanianLyric = romanianLyricModel[k].romanianLyric
                                                                                                                        break
                                                                                                                        }
                        lyricModel.push({
                                        "time": originalLyricModel[i].time,
                                        "originalLyric": originalLyricModel[i].originalLyric,
                                        "translatedLyric": _translatedLyric,
                                        "romanianLyric": _romanianLyric
                        })
                    }
                    lyricView.model.clear()
                    for (var n in lyricModel) {
                        lyricView.model.append({
                            "time": lyricModel[n].time,
                            "originalLyric": lyricModel[n].originalLyric,
                            "translatedLyric": lyricView.hasTranslatedLyric? lyricModel[n].translatedLyric : "",
                            "romanianLyric": lyricView.hasRomanianLyric? lyricModel[n].romanianLyric : ""
                        })
                    }
                }
            }
        }
    }
}
