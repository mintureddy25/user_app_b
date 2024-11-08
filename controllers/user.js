const express = require("express");
const router = express.Router();
const pool = require("../db");
const { verifyToken } = require("../middleware/middleware");
const multer = require('multer');



// Configure multer storage options
const storage = multer.memoryStorage();  // Store file in memory as a buffer (alternative: diskStorage)
const upload = multer({ storage: storage, limits: { fileSize: 5 * 1024 * 1024 } }); // Limit file size (5MB)

// PUT route to update user profile
router.put("/:userId", verifyToken, upload.single('profilePicture'), async (req, res) => {
    const userId = req.params.userId;
    const { name, gender, age } = req.body;
    const profilePicture = req.file ? req.file.buffer : null; // File data is available in req.file.buffer

    // Validate fields
    if (!name || name.trim().length === 0) {
        return res.status(400).json({ message: "Invalid name" });
    }
    if (!["Male", "Female", "Trans"].includes(gender)) {
        return res.status(400).json({ message: "Invalid gender. Please select Male, Female, or Trans." });
    }
    if (isNaN(age) || age < 0) {
        return res.status(400).json({ message: "Invalid age. Please enter a valid age." });
    }

    // Query to check if the user exists
    const query = "SELECT * FROM users WHERE id = ?";
    const [rows] = await pool.execute(query, [userId]);

    if (rows.length === 0) {
        return res.status(404).json({ message: "User not found" });
    }

    // SQL query to update user details
    const updateQuery = `
        UPDATE users
        SET name = ?, gender = ?, age = ?, profile_picture = ?
        WHERE id = ?
    `;

    try {
        const result = await pool.execute(updateQuery, [
            name,
            gender,
            age,
            profilePicture || null,  // Use the file buffer, or null if no file
            userId
        ]);

        res.status(200).json({ message: 'User details updated successfully', data: result });
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

        // Get the user data
        const user = userRows[0];

        // Return user details, including profile picture BLOB as a base64-encoded string
        return res.status(200).json({
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                gender: user.gender,
                age: user.age,
                profile_picture: user.profile_picture ? `data:image/jpeg;base64,${Buffer.from(user.profile_picture).toString('base64')}` : null,
                last_login: user.last_login
            }
        });

    } catch (error) {
        console.error('Error executing query', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.get('/:userId/friends', verifyToken, async (req, res) => {
    const userId = req.params.userId;

    try {
        const query = `
            SELECT u.id, u.name, u.gender, u.age, u.profile_picture
            FROM users u
            JOIN friends f ON f.user_id = ? AND f.friend_id = u.id
        `;
        const [friendsRows] = await pool.execute(query, [userId]);

        // If no friends found
        if (friendsRows.length === 0) {
            return res.status(404).json({ message: "No friends found" });
        }

        // Transform friends data
        const friends = friendsRows.map(friend => ({
            id: friend.id,
            name: friend.name,
            gender: friend.gender,
            age: friend.age,
            profile_picture: friend.profile_picture ? `data:image/jpeg;base64,${Buffer.from(friend.profile_picture).toString('base64')}` : null
        }));

        return res.status(200).json({ friends });

    } catch (error) {
        console.error('Error executing query', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});



module.exports = router;

  