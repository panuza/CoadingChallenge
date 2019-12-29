
<template>
  <div class="max-w-md m-auto py-10">
    <div>
      <marquee><strong>User Token: {{token}}</strong></marquee>
    </div>
    <div class="container pt-5">
      <div class="row">
        <div class="col-md-6">
          <h3>All Challenges</h3>
        </div>
        <div class="col-md-6">
           <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
           @click.prevent="createChallenge">Create new Challenge</button>
        </div>
      </div>
      <div class="row pt-5">
        <table class="py-4" >
          <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Question</th>
            <th>Category</th>
            <th>Difficulty Level</th>
            <th></th>
          </tr>
          <tr v-for="challenge in challenges" :key="challenge.id" :challenge="challenge">
            <td>{{challenge.name}}</td>
            <td>{{challenge.description}}</td>
            <td>{{challenge.question}}</td>
            <td>{{challenge.category}}</td>
            <td>{{challenge.difficulty_level}}</td>
            <td><a href="#" class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
           @click.prevent="createAnswer(challenge.id)">Answers</a></td>
          </tr>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Challenges',
  data () {
    return {
      challenges: [],
      newChallenge: [],
      error: '',
      editedChallenge: '',
      token: 'nil'
    }
  },
  mounted(){
    // window.location.reload(true);
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/challenges')
        .then(response => { this.challenges = response.data.challenges; this.token = response.data.token })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    createChallenge(){
      this.$router.replace('/createChallenges')
    },
    createAnswer(id){
      this.$router.replace(`/answers/${id}`)
    },
  }
}
</script>
<style scoped>
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
