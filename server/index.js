const express = require('express');
const multer = require('multer');
const bodyParser = require('body-parser');
const fs = require('fs');
const app = express();
const PORT = 3000;

app.use(bodyParser.json());

// إعداد المولتر لتحميل الصور
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  },
});
const upload = multer({ storage: storage });

let foodItems = [];

// GET: استرجاع العناصر الغذائية
app.get('/food-items', (req, res) => {
  res.json(foodItems);
});

// POST: إضافة عنصر غذائي جديد
app.post('/food-items', upload.single('image'), (req, res) => {
  const { name, price, description, category } = req.body;
  const image = req.file ? req.file.path : null;

  const newFoodItem = {
    id: Date.now().toString(),
    name,
    price: parseFloat(price),
    description,
    category,
    image,
  };

  foodItems.push(newFoodItem);
  res.status(201).json(newFoodItem);
});

// PUT: تعديل عنصر غذائي
app.put('/food-items/:id', upload.single('image'), (req, res) => {
  const { id } = req.params;
  const { name, price, description, category } = req.body;
  const image = req.file ? req.file.path : null;

  const index = foodItems.findIndex(item => item.id === id);

  if (index !== -1) {
    foodItems[index] = {
      id,
      name,
      price: parseFloat(price),
      description,
      category,
      image: image || foodItems[index].image,
    };
    res.json(foodItems[index]);
  } else {
    res.status(404).json({ message: 'Item not found' });
  }
});

// DELETE: حذف عنصر غذائي
app.delete('/food-items/:id', (req, res) => {
  const { id } = req.params;
  const index = foodItems.findIndex(item => item.id === id);

  if (index !== -1) {
    const deletedItem = foodItems.splice(index, 1);
    res.json(deletedItem);
  } else {
    res.status(404).json({ message: 'Item not found' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
