import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Signin from '@/components/Signin'
import Signup from '@/components/Signup'
import Challenge from '@/components/Challenge'
import CreateChallenge from '@/components/CreateChallenge'
import Answer from '@/components/Answer'
import CreateAnswer from '@/components/CreateAnswer'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/createchallenges',
      name: 'CreateChallenge',
      component: CreateChallenge
    },
    {
      path: '/createanswers/:challenge_id',
      name: 'CreateAnswer',
      component: CreateAnswer
    },
    {
      path: '/answers/:challenge_id',
      name: 'Answer',
      component: Answer
    },
  	{
      path: '/challenges',
      name: 'Challenge',
      component: Challenge
    },
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    }
  ]
})
