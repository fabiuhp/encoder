package domain

import (
	"time"

	"github.com/asaskevich/govalidator"
)

type Video struct {
	ID         string
	ResourceID string
	FilePath   string
	CreatedAt  time.Time
}

func NewVideo() *Video {
	return &Video{}
}

func (v *Video) Validate() error {
	_, err := govalidator.ValidateStruct(v)
	if err != nil {
		return err
	}
	return nil
}

func (v *Video) IsEmpty() bool {
	return v.ID == "" && v.ResourceID == "" && v.FilePath == ""
}
