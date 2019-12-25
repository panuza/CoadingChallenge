
<template>
  <div class="max-w-md m-auto py-10">
    <div class="container pt-5">
      <div class="row">
        <div class="col-md-6">
          <!-- <div v-if="answers.length <= 0">
            <h3>No answers available in a challenge</h3>
          </div>
          <div v-else> -->
            <h3>All answers in a challenge</h3>
          <!-- </div> -->
        </div>
        <div class="col-md-6">
           <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
           @click.prevent="createAnswer">Create new Answer</button>
        </div>
      </div>
      <div class="row pt-5">
        <!-- <div class="row w-100" v-if="answers.length > 0"> -->
          <table class="py-4" >
            <tr>
              <th>Answer</th>

            </tr>
            <tr v-for="answer in answers" :key="answer.id" :answer="answer">
              <td>
                <div class="row">
                  <div class="col-md-6">{{answer.answer}}</div>
                  <div v-if="user.id !== answer.user_id" class="col-md-3" @click="upVote(answer.id)"><a  href="#">Vote Up</a></div>
                  <div v-if="user.id !== answer.user_id && user.skill_level >= 10" class="col-md-3" @click="downVote(answer.id)"><a  href="#">Vote Down</a></div>
                  </div>
              </td>
            </tr>
          </table>
        <!-- </div> -->
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
    },
    upVote(id){
      if(id){
        this.$http.secured.get(`/api/v1/answers/upVote/${id}`)
          .then(response => {
            this.answers = response.data 
            this.$router.replace('/challenges')
            alert("You have voted successfully")
          })
          .catch(error => this.setError(error, 'Something went wrong'))
      }
    },
    downVote(id){
      if(id){
        this.$http.secured.get(`/api/v1/answers/downVote/${id}`)
        .then(response => {
          this.answers = response.data 
          this.$router.replace('/challenges')
          alert("You have down voted successfully")

        })
        .catch(error => this.setError(error, 'Something went wrong'))
      }
    },
    
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

</style>