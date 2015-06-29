//: Playground - noun: a place where people can play

import Foundation
/*
public class Summary {
    
    func splitContentToSentences(content:String) -> [String]
    {
        return splitContent(content, enumerationOption: NSStringEnumerationOptions.BySentences)
    }
    
    func splitContentToParagraphs(content:String) -> [String]
    {
        return splitContent(content, enumerationOption: NSStringEnumerationOptions.ByParagraphs)
    }
    
    func splitContentToWords(content:String) -> [String]
    {
        if(count(content) == 0)
        {
            return []
        } else {
            return content.componentsSeparatedByString(" "); //This is a lot faster than the implementation below
            //        return splitContent(content, enumerationOption: NSStringEnumerationOptions.ByWords)
        }
    }
    
    func splitContent(content:String, enumerationOption:NSStringEnumerationOptions) -> [String]
    {
        var contentString = content as NSString
        
        var splitContent = [String]()
        
        contentString.enumerateSubstringsInRange(NSMakeRange(0, (contentString as NSString).length), options: enumerationOption) { (splitString, substringRange, enclosingRange, stop) -> () in
            
            var trimmedString = splitString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            //remove blank lines
            if(count(trimmedString) > 0)
            {
                splitContent.append(trimmedString as String)
            }
        }
        
        return splitContent
    }
    
    func getSentencesIntersectionScore(sent1:String, sent2:String) -> Float
    {
        //split sentences to words
        let s1 = splitContentToWords(sent1)
        let s2 = splitContentToWords(sent2)
        
        //if no words, then score is 0.
        if s1.count + s2.count == 0
        {
            return 0
        }
        
        //find intersection elements between S1 and S2
        let s1InS2 = getStringArrayIntersectionCaseInsensitive(s1, arr2: s2)
        
        //score is the normalised intersection value
        return Float(s1InS2.count) / (Float(s1.count + s2.count)/2.0)
    }
    
    func getStringArrayIntersectionCaseInsensitive(arr1:[String], arr2:[String]) -> [String]
    {
        let lowerCaseArr2 = arr2.map({$0.lowercaseString})
        
        return arr1.filter({contains(lowerCaseArr2, $0.lowercaseString)})
    }
    
    func formatSentence(sentence:String) -> String
    {
        let regex = NSRegularExpression(pattern:"\\W+", options: .CaseInsensitive, error: nil)
        let modifiedString = regex!.stringByReplacingMatchesInString(sentence, options: nil, range: NSRange(location: 0,length: count(sentence)), withTemplate: "")
        
        return modifiedString
    }
    
    func getSentenceRanks(content:String) -> [String:Float]
    {
        var sentences = splitContentToSentences(content)
        
        var n = sentences.count
        
        var values = [[Float]]()
        
        //calculate intersection of every two sentences
        
        for i in 0 ... n-1 {
            var jValues = [Float]()
            
            for j in 0 ... n-1 {
                jValues.append(getSentencesIntersectionScore(sentences[i], sent2: sentences[j]))
            }
            
            values.append(jValues)
        }
        
        //build overall sentence scores.
        //the overall score of a sentence is the sum of all its individual intersection scores.
        
        var sentencesDictionary = [String:Float]()
        
        for i in 0 ... n-1 {
            var score:Float = 0.0
            var jValues = [Float]()
            
            for j in 0 ... n-1 {
                if(i == j)
                {
                    continue
                }
                
                score += values[i][j]
            }
            
            sentencesDictionary[formatSentence(sentences[i])] = score
        }
        
        return sentencesDictionary
    }
    
    //return the best sentence in a paragraph
    func getBestSentence(paragraph:String, sentencesDictionary:[String: Float]) -> String
    {
        //Split the paragraph into sentences
        var sentences = splitContentToSentences(paragraph)
        
        if(sentences.count < 2) {
            return ""
        }
        
        //Get best sentence according to the sentences dictionary
        var bestSentence = ""
        var maxValue:Float = 0.0
        
        for s in sentences {
            var formatedSentence = formatSentence(s)
            
            if(count(formatedSentence) > 0)
            {
                if sentencesDictionary[formatedSentence] > maxValue
                {
                    maxValue = sentencesDictionary[formatedSentence]!
                    bestSentence = s
                }
            }
        }
        
        return bestSentence
    }
    
    public func getSummary(title:String, content:String) -> String
    {
        var sentencesDictionary = getSentenceRanks(content)
        
        //split content into paragraphs
        var paragraphs = splitContentToParagraphs(content)
        
        //add title
        var summary = [String]()
        
        //summary.append(title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        //summary.append("")
        
        for paragraph in paragraphs {
            var sentence = getBestSentence(paragraph, sentencesDictionary: sentencesDictionary)
            var trimmedSentence = sentence.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if count(trimmedSentence) > 0 {
                summary.append(trimmedSentence)
            }
        }
        
        return "".join(summary)
    }
}

var summary  =   Summary()

var abstarct = summary.getSummary("shell 编程技术", content: "Shell 是操作系统的最外层。shell 合并编程语言以控制进程和文件，以及启动和控制其它程序。shell 通过提示输入，向操作系统解释该输入，然后处理来自操作系统的任何结果输出来管理您与操作系统之间的交互。Shell 提供了与操作系统通信的方式。此通信以交互的方式(来自键盘输入立即操作)或作为一个 shell 脚本执行。shell 脚本是 shell 和操作系统命令的序列，它存储在文件中。当登录到系统中时，系统定位要执行的 Shell 的名称。在它执行之后，Shell 显示一个命令提示符。此提示符通常是一个 $(美元符)。当提示符下输入命令并按下 Enter 键时，shell 对命令进行求值，并尝试执行它。取决于命令hell 将命令输出写到屏幕或重定向到输出。然后它返回命令提示符，并等待您输入另一个命令。命令行是输入所在的行。它包含 Shell 提示符。每行的基本格式如下：")

abstarct
*/
var timeDatas = [Int64](count:5, repeatedValue: 0)
timeDatas[0] =  1
timeDatas[1] =  2
timeDatas[2] =  3
timeDatas
