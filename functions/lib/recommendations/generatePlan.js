"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generatePlan = void 0;
const functions = require("firebase-functions");
exports.generatePlan = functions.https.onRequest((req, res) => {
    const goal = req.body.goal || 'default';
    const mealPlans = {
        "weight_loss": ["Salad with chicken", "Steamed veggies", "Grilled tofu"],
        "muscle_gain": ["Protein shake", "Beef rice bowl", "Eggs & oatmeal"],
        "maintain": ["Balanced plate", "Chicken stir-fry", "Smoothie"],
        "default": ["Sandwich", "Fruit bowl", "Pasta"]
    };
    const meals = mealPlans[goal] || mealPlans["default"];
    res.status(200).send({ goal, meals });
});
