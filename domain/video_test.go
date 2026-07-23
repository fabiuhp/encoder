package domain

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestValidateIfVideoIsEmpty(t *testing.T) {
	video := NewVideo()
	err := video.Validate()

	require.Error(t, err)
}

func TestVideoIdIsNotUUID(t *testing.T) {
	video := NewVideo()

	video.ID = "123"
	video.ResourceID = "resource-id"
	video.FilePath = "/path/to/file"
	video.CreatedAt = time.Now()

	err := video.Validate()

	require.Error(t, err)
}
