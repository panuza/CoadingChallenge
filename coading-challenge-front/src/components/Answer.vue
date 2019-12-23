
<template>
  <div class="max-w-md m-auto py-10">
    <div class="container pt-5">
      <div class="row">
        <div class="col-md-6">
          <div v-if="answers.length <= 0">
            <h3>No answers available in a challenge</h3>
          </div>
          <div v-else>
            <h3>All answers in a challenge</h3>
          </div>
        </div>
        <div class="col-md-6">
           <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
           @click.prevent="createAnswer">Create new Answer</button>
        </div>
      </div>
      <div class="row pt-5">
        <div class="row w-100" v-if="answers.length > 0">
          <table class="py-4" >
            <tr>
              <th>Answer</th>
            </tr>
            <tr v-for="answer in answers" :key="answer.id" :answer="answer">
              <td>{{answer.answer}}</td>
              <!-- <td><a href="#" class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
             @click.prevent="createAnswer(answer.id)">Answer the challenge</a></td> -->
            </tr>
          </table>
        </div>
      </div>
    </div>
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

    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get(`/api/v1/answers/challengeAnswers/${this.challenge_id}`)
        .then(response => {
          this.answers = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    createAnswer(){
      this.$router.replace(`/createAnswers/${this.challenge_id}`)
    }
  }
}
</script>
<style>
  table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>