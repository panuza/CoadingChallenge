
<template>
  <div class="max-w-md m-auto py-10">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Add a new Challenge</h3>
    <form action="" @submit.prevent="addChallenge">
      <div class="mb-6">
        <label>Name</label>
        <input class="input"
          autofocus autocomplete="off"
          placeholder="Type challenge name"
          v-model="newChallenge.name" />
      </div>
      <div class="mb-6">
        <label class="label">Description</label>
        <input class="input" placeholder="Description" v-model="newChallenge.description" />
      </div>
      <div class="mb-6">
        <label class="label">Question</label>
        <input class="input" placeholder="Type your question" v-model="newChallenge.question" />
      </div>
      <div class="mb-6">
        <label class="label" for="category">Category</label>
        <select id="category" class="select" v-model="newChallenge.category">
          <option>Sports</option>
          <option>History</option>
          <option>Science</option>
          <option>Geography</option>
        </select>
      </div>
      <div class="mb-6">
        <label class="label" for="difficulty_level">Difficulty Level</label>
        <select id="difficulty_level" class="select" v-model="newChallenge.difficulty_level">
          <option>1</option>
          <option>2</option>
          <option>3</option>
          <option>4</option>
        </select>
      </div>
      <input type="submit" value="Add Challenge" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center" />
    </form>

    <hr class="border border-grey-light my-6" />

    <h3>My Challenges</h3>
    <ul class="list-reset mt-4">
      <li class="py-4" v-for="challenge in challenges" :key="challenge.id" :challenge="challenge">

        <div class="flex items-center justify-between flex-wrap">
          <p class="block flex-1 font-mono font-semibold flex items-center ">
            {{ challenge.name }}
          </p>

          <button class="bg-tranparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
          @click.prevent="editChallenge(challenge)">Edit</button>

          <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
         @click.prevent="removeChallenge(challenge)">Delete</button>
        </div>

        <div v-if="challenge == editedChallenge">
          <form action="" @submit.prevent="updateChallenge(challenge)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">
              <input class="input" v-model="challenge.name" />
              <div class="mb-6">
                <label class="label">Description</label>
                <input class="input" placeholder="Description" v-model="challenge.description" />
              </div>
              <div class="mb-6">
                <label class="label">Question</label>
                <input class="input" placeholder="Type your question" v-model="challenge.question" />
              </div>
              <div class="mb-6">
                <label class="label" for="category">Category</label>
                <select id="category" class="select" v-model="challenge.category">
                  <option>Sports</option>
                  <option>History</option>
                  <option>Science</option>
                  <option>Geography</option>
                </select>
              </div>
              <div class="mb-6">
                <label class="label" for="difficulty_level">Difficulty Level</label>
                <select id="difficulty_level" class="select" v-model="challenge.difficulty_level">
                  <option>1</option>
                  <option>2</option>
                  <option>3</option>
                  <option>4</option>
                </select>
              </div>
              <input type="submit" value="Update" class=" my-2 bg-transparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 rounded cursor-pointer">
            </div>
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
        .catch(error => this.setError(error, 'Cannot update challenge'))
    }
  }
}
</script>