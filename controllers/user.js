const express = require("express");
const router = express.Router();
const pool = require("../db");
const { verifyToken } = require("../middleware/middleware");


function isNotEmpty(value) {
  return value && value.trim() !== "";
}

router.put("/:userId", verifyToken, async (req, res) => {
    const userId = req.params.userId;  
    const { name, gender, age, profilePicture } = req.body;  
  
    // Validate fields
    if (!isNotEmpty(name)) {
        return res.status(400).json({ message: "Invalid name" });
    }
    if (!["Male", "Female", "Trans"].includes(gender)) {
        return res.status(400).json({ message: "Invalid gender. Please select Male, Female, or Trans." });
    }
    if (isNaN(age) || age < 0) {
        return res.status(400).json({ message: "Invalid age. Please enter a valid age." });
    }
    if (profilePicture && !Buffer.isBuffer(profilePicture)) {
        return res.status(400).json({ message: "Invalid profile picture. Please upload a valid image file." });
    }
  
    try {
        // Query to check if the user exists
        const query = "SELECT * FROM users WHERE id = ?";
        const [rows] = await pool.execute(query, [userId]);

        if (rows.length === 0) {
            return res.status(404).json({ message: "User not found" });
        }

        const updateQuery = `
            UPDATE users
            SET name = ?, gender = ?, age = ?, profile_picture = ?
            WHERE id = ?
        `;
        
        // If there's no profile picture provided, set it as NULL (assuming the column allows NULL)
        const profilePictureData = profilePicture ? profilePicture : null;

        const [result] = await pool.execute(updateQuery, [
            name,
            gender,
            age,
            profilePictureData,
            userId
        ]);
        
        res.status(200).json({ message: 'User details updated successfully' });
    } catch (error) {
        console.error('Error executing query', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.get('/:userId', verifyToken, async (req, res) => {
    const userId = req.params.userId;  

    try {
        
        const userQuery = "SELECT * FROM users WHERE id = ?";
        const [userRows] = await pool.execute(userQuery, [userId]);

        // If no user found, return a 404 response
        if (userRows.length === 0) {
            return res.status(404).json({ message: "User not found" });
        }

        // If user found, return user details
        return res.status(200).json({ user: userRows[0] });

    } catch (error) {
        console.error('Error executing query', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;

  