
<template>
  <div class="m-auto my-8 text-center pt-5 col-md-4 offset-md-4 ">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Add a new Challenge</h3>
    <form @submit.prevent="addChallenge" class="w-100">
        <div class="text-red" v-if="error">{{ error }}</div>
          <div class="row">
            <div class="mb-6 col-md-6">
              <label class="level"><strong>Name</strong></label>
              <input type="text" v-model="newChallenge.name" class="input" id="name" placeholder="Enter challenge name">
            </div>
            <div class="mb-6 col-md-6">
            <label class="label"><strong>Question</strong></label>

            <input type="text" v-model="newChallenge.question" class="input" id="question" placeholder="Type your question">
          </div>
        </div>
        <div class="row">
          <div class="mb-6 col-md-6">
            <label class="label" for="category"><strong>Category</strong></label>
            <select id="category" class="custom-select" v-model="newChallenge.category">
              <option selected>Select category</option>
              <option>Sports</option>
              <option>History</option>
              <option>Science</option>
              <option>Geography</option>
            </select>
          </div>
          <div class="mb-6 col-md-6">
            <label class="label" for="difficulty_level"><strong>Difficulty Level</strong></label>
            <select id="difficulty_level" class="custom-select" v-model="newChallenge.difficulty_level">
              <option>1</option>
              <option>2</option>
              <option>3</option>
              <option>4</option>
            </select>
          </div>
        </div>

        <div class="form-group col-md-12">
            <label for="description"><strong>Description</strong></label>
            <textarea class="form-control" type="text" v-model="newChallenge.description" id="description" placeholder="Description of your challenge" rows="2"></textarea>
          </div>
       
        <input type="submit" class="fadeIn fourth mt-3" value="Add Challenge"></input>
      </form>

    <hr class="border border-grey-light my-6" />

    <h3 class="text-center">My Challenges</h3>
    <ul class="list-reset mt-4">
      <li class="py-4" v-for="challenge in challenges" :key="challenge.id" :challenge="challenge" style="list-style-type: none;">

        <div class="flex items-center justify-between flex-wrap">
          <p class="block flex-1 font-mono font-semibold flex items-center ">
            {{ challenge.name }}
          </p>

          <button class="btn-custom bg-tranparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
          @click.prevent="editChallenge(challenge)">Edit</button>

          <button class="btn-danger bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
         @click.prevent="removeChallenge(challenge)">Delete</button>
        </div>

        <div v-if="challenge == editedChallenge">
          <form @submit.prevent="updateChallenge(challenge)" class="w-100">
            <div class="row">
              <div class="mb-6 col-md-6">
                <label class="level"><strong>Name</strong></label>
                <input type="text" v-model="challenge.name" class="input" id="name">
              </div>
              <div class="mb-6 col-md-6">
              <label class="label"><strong>Question</strong></label>

              <input type="text" v-model="challenge.question" class="input" id="question">
            </div>
          </div>
          <div class="row">
            <div class="mb-6 col-md-6">
              <label class="label" for="category"><strong>Category</strong></label>
              <select id="category" class="custom-select" v-model="challenge.category">
                <option selected>Select category</option>
                <option>Sports</option>
                <option>History</option>
                <option>Science</option>
                <option>Geography</option>
              </select>
            </div>
            <div class="mb-6 col-md-6">
              <label class="label" for="difficulty_level"><strong>Difficulty Level</strong></label>
              <select id="difficulty_level" class="custom-select" v-model="challenge.difficulty_level">
                <option>1</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
              </select>
            </div>
          </div>

          <div class="form-group col-md-12">
              <label for="description"><strong>Description</strong></label>
              <textarea class="form-control" type="text" v-model="challenge.description" id="description" placeholder="Description of your challenge" rows="2"></textarea>
            </div>
         
          <input type="submit" class="fadeIn fourth mt-3" value="Add Challenge"></input>
        </form>
        </div>
      </li>
    </ul>
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
      user: ''
    }
  },
  mounted (){

  },
  created () {
    this.$http.secured.get('/api/v1/users.json')
    .then(res => {
      this.user = res.data;
    })
    .catch(error=>{});

    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get(`/api/v1/challenges/myChallenges/${this.user.id}`)
        .then(response => { this.challenges = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addChallenge () {
      const value = this.newChallenge
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/challenges/', { challenge: { name: this.newChallenge.name, description: this.newChallenge.description, question: this.newChallenge.question, category: this.newChallenge.category, difficulty_level: this.newChallenge.difficulty_level } })

        .then(response => {
          this.challenges.push(response.data)
          this.newChallenge = ''
        })
        .catch(error => this.setError(error, 'Cannot create challenge'))
    },
    removeChallenge (challenge) {
      this.$http.secured.delete(`/api/v1/challenges/${challenge.id}`)
        .then(response => {
          this.challenges.splice(this.challenges.indexOf(challenge), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete challenge'))
    },
    editChallenge (challenge) {
      this.editedChallenge = challenge
    },
    updateChallenge (challenge) {
      this.editedChallenge = ''
      this.$http.secured.patch(`/api/v1/challenges/${challenge.id}`, { challenge: { name: this.newChallenge.name, description: this.newChallenge.description, question: this.newChallenge.question, category: this.newChallenge.category, difficulty_level: this.newChallenge.difficulty_level } })
        .catch(error => this.setError(error, ''))
    }
  }
}
</script>