package domain

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateIfVideoIsEmpty(t *testing.T) {
	video := NewVideo()
	err := video.Validate()

	require.Error(t, err)
}
