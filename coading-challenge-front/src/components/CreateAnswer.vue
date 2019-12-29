
<template>
  <div class="max-w-md m-auto py-10 col-md-6 offset-md-6">
    <div style="color: red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Add your Answer</h3>
    <form action="" @submit.prevent="addAnswer">
      <div class="">
        <input type="text" v-model="newAnswer.answer" class="input" id="answer" placeholder="Type your answer">
      </div>
    <!--   <div class="mb-6">
        <label>Answer</label>
        <input class="input"
          autofocus autocomplete="off"
          placeholder="Type your answer"
          v-model="newAnswer.answer" />
      </div> -->
      <input type="submit" value="Add Answer" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center" />
    </form>
  </div>
</template>

<script>
export default {
  name: 'Answers',
  data () {
    return {
      answers: [],
      newAnswer: [],
      error: '',
      editedAnswer: '',
      user: '',
      challenge_id: ''
    }
  },
  mounted (){

  },
  created () {
    var current_url = this.$route.path.split('/')
    this.challenge_id = parseInt(current_url[2], 10)

    this.$http.secured.get('/api/v1/users.json')
    .then(res => {
      this.user = res.data;
    })
    .catch(error=>{});

    // if (!localStorage.signedIn) {
    //   this.$router.replace('/')
    // } else {
    //   this.$http.secured.get(`/api/v1/answers/myAnswers/${this.user.id}`)
    //     .then(response => { this.answers = response.data })
    //     .catch(error => this.setError(error, 'Something went wrong'))
    // }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addAnswer () {
      const value = this.newAnswer
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/answers/', { answer: { answer: this.newAnswer.answer, challenge_id: this.challenge_id, user_id: this.user.id } })

        .then(response => {
          this.answers.push(response.data)
          this.newAnswer = ''
          this.$router.replace(`/answers/${this.challenge_id}`)
        })
        .catch(error => this.setError(error, 'Cannot create answer'))
    },
  }
}
</script>