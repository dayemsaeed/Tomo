package com.lumen.tomo.model.llmreponse

data class GPTResponse(val choices: List<Choice>) {
    data class Choice(val message: Message) {
        data class Message(val content: String)
    }
}
